import datetime
import sys
from email import message
from functools import wraps
from random import randint
import bcrypt
import mysql.connector
from flask import (Flask, flash, jsonify, logging, redirect, render_template,
                   request, session, url_for)
from flask_mysqldb import MySQL
from mysql.connector import Error
from passlib.hash import sha256_crypt
from wtforms import Form, PasswordField, StringField, TextAreaField, DateField, TimeField, validators, SelectField


# Kullanıcı Giriş Decorator'ı (login gerekli)
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "logged_in" in session:
            return f(*args, **kwargs)
        else:
            flash("Bu sayfayı görüntülemek için lütfen giriş yapın.","danger")
            return redirect(url_for("login"))

    return decorated_function

#kullanıcı kayıt formu
class RegisterForm(Form):
    name = StringField("İsim Soyisim", validators=[validators.Length(min=4,max=25)])
    username = StringField("Kullanıcı Adı", validators=[validators.Length(min=4,max=15)])
    email = StringField("Email Adresi", validators=[validators.Email(message="Lütfen geçerli bir Email adresi giriniz.")])
    password = PasswordField("Parola:", validators=[
        validators.DataRequired(message="Lütfen bir parola belirleyiniz."),
        validators.EqualTo(fieldname="confirm",message="Parolanız Uyuşmuyor...")])
    confirm=PasswordField("Parola Doğrula")

#Login formu
class LoginForm(Form):
    username = StringField("Kullanıcı Adı")
    password = PasswordField("Parola")

app = Flask(__name__)
app.secret_key = "ybblog" #flask mesajlarını yayınlamak için secret key olmak zorunda

app.config["MYSQL_HOST"]="localhost"
app.config["MYSQL_USER"]="root"
app.config["MYSQL_PASSWORD"]=""
app.config["MYSQL_DB"]="ybblog"
app.config["MYSQL_CURSORCLASS"]="DictCursor"

mysql = MySQL(app)

#Ana Sayfa
@app.route("/") #request
def index():
    return render_template("index.html")
#Filmler Sayfası
@app.route("/about") #request
def about():
    return render_template("about.html")

#Register (Kayıt olma)
@app.route("/register",methods=["GET","POST"])
def register():
    form = RegisterForm(request.form)
    
    if request.method == "POST" and form.validate():
        #veri tabanına kullanıcı kaydı
        name = form.name.data
        username = form.username.data
        email = form.email.data
        password = sha256_crypt.encrypt(form.password.data) #bu fonksiyon sayesinde parolayı şifrelemiş olduk 
        
        cursor = mysql.connection.cursor() #sql bağlantısını açma
        
        sorgu = "Insert into users(name,email,username,password) VALUES(%s,%s,%s,%s)"

        cursor.execute(sorgu,(name,email,username,password))
        
        mysql.connection.commit() #veri tabanında güncelleme yaptığımız için commiti yapmak zorundayız

        cursor.close() #sql bağlantısını kapatma

        flash("Kayıt Olma İşlemi Başarılı...","success") #Anasayfada mesaj yayınlamak için

        return redirect(url_for("login")) #kayıt olduktan sonra bizi anasayfaya döndürüyor (GET request)
    else:
        pass


    return render_template("register.html",form=form)

#Login islemi
@app.route("/login",methods =["GET","POST"])
def login():
    form = LoginForm(request.form)
    if request.method == "POST": 
        username = form.username.data
        password_entered = form.password.data

        cursor = mysql.connection.cursor()
        sorgu = "Select * From users where username = %s"

        result = cursor.execute(sorgu,(username,))

        if result > 0:
            data = cursor.fetchone()
            real_password = data["password"]
            if sha256_crypt.verify(password_entered,real_password):
                
                session["logged_in"]=True
                session["username"]=username
                session["role"]=data["role"]

                if data["role"]==1:
                    flash("Yönetici Olarak Giriş Yaptınız","success")
                    return redirect(url_for("manager"))
                else:
                    flash("Başarıyla Giriş Yaptınız...","success")
                    return redirect(url_for("customer"))
    
            else:
                flash("Lütfen Giriş Bilgilerinizi Kontrol Ediniz...","danger")
                return redirect(url_for("login"))
        else:
            flash("Böyle bir kullanıcı bulunmuyor...","danger")
            return redirect(url_for("login"))
        
    return render_template("login.html",form=form)

#Manager Function
@app.route('/seanslar', methods=["GET",'POST'])
def seanslar():
    if request.method=="GET":
        cursor=mysql.connection.cursor()
        sorgu="Select * from movies"
        result = cursor.execute(sorgu)
        if result > 0:
            movies=cursor.fetchall()
            return render_template("seanslar.html",movies=movies)
            
        else:
            flash("Formdan veri gelmedi!!!","danger")
            return render_template("seanslar.html")
   

# Mysql'e Manager Tarafından Film Ekleme
@app.route('/manager', methods=["GET",'POST'])
@login_required
def manager():
    if request.method=="POST":
        title = request.form.get('title')
        hall = request.form.get('hall')
        show_start = request.form.get('show_start')
        time = request.form.get('time')

        cursor = mysql.connection.cursor() #sql bağlantısını açma
        
        sorgu = "INSERT INTO movies(title, hall, show_start, time) VALUES(%s,%s,%s,%s)"

        cursor.execute(sorgu,(title, hall, show_start, time))
        
        mysql.connection.commit()
        cursor.close()
        return redirect(url_for("seanslar")) 
        
    else:
        return render_template("manager.html")

#Seans Seçme
@app.route("/customer",methods =["GET","POST"])
def customer():
    if request.method == "GET": 
        title = request.form.get('title')
        hall = request.form.get('hall')
        show_start = request.form.get('show_start')
        time = request.form.get('time')

        return render_template("customer.html",title=title, hall=hall, show_start=show_start, time=time)
    else:
        pass

    return render_template("customer.html")


#BiletAl Function
@app.route('/biletal/<string:title>',methods =["GET","POST"])
@login_required
def biletAl(title):
    if session["role"]==1:
        flash("Yönetici Bilet Alamaz!!!","warning")
        return render_template("seanslar.html")
    else:
        cursor = mysql.connection.cursor() #sql bağlantısını açma
        sorgu1 ="SELECT * FROM movies WHERE title = %s"
        cursor.execute(sorgu1,(title,))
        result=cursor.fetchone()
        sorgu2="SELECT * FROM booked_tickets WHERE title=%s"
        cursor.execute(sorgu2,(title,))
        result2=cursor.fetchall()
        if len(result2)<=20: #hall kapasite=20
            sorgu = "INSERT INTO booked_tickets(title, hall, show_start, time) VALUES(%s,%s,%s,%s)"

            cursor.execute(sorgu,(result["title"], result["hall"], result["show_start"], result["time"]))
            mysql.connection.commit()
            cursor.close()

            return render_template("biletal.html")
        else:
            flash("Bu Salon Doldu...","danger")
            return render_template("seanslar.html")


#Bilet Sil
@app.route('/seanssil/<string:title>',methods =["GET","POST"])
def seanssil(title):
    
        cursor = mysql.connection.cursor() #sql bağlantısını açma
        sorgu= "SELECT * FROM movies WHERE title=%s"
        result=cursor.execute(sorgu,(title,))
        
        if result>0:
            sorgu2="DELETE FROM movies WHERE title=%s"
            cursor.execute(sorgu2,(title,))
            mysql.connection.commit()
            return redirect(url_for("seansil"))
        else:
            flash("Böyle bir Film yok...","danger")    
            return redirect(url_for("seansil"))
        
#Manager Function
@app.route('/seansil')
def seansil():
    if request.method=="GET":
        cursor=mysql.connection.cursor()
        sorgu="Select * from movies"
        result = cursor.execute(sorgu)
        if result > 0:
            movies=cursor.fetchall()
            return render_template("seanssil.html",movies=movies)
        else:
            flash("Formdan veri gelmedi!","danger")
            return render_template("seanssil.html")
   
   

#Logout İşlemi
@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("index")) #çıkış yapınca anasayfaya döndürdü

if __name__ == "__main__":
    app.run(debug=True)
 