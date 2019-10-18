from flask import Blueprint, redirect, render_template, request
from flask_login import current_user, login_required, login_user, logout_user

from __init__ import db, login_manager
from forms import LoginForm, RegistrationForm, CarRegistrationForm, BidForm
from models import AppUser

view = Blueprint("view", __name__)

@login_manager.user_loader
def load_user(username):
    user = AppUser.query.filter_by(username=username).first()
    return user or current_user


@view.route("/", methods=["GET", "POST"])
def render_home_page():
    if current_user.is_authenticated:
        ad_list_query = "SELECT date(a.departure_time) as date, a.departure_time::time(0) as time, a.from_place, a.to_place, a.num_passengers," \
                "(SELECT max(price) from bids b where b.time_posted = a.time_posted and b.driver_id = a.driver_id) as highest_bid," \
                "(SELECT count(*) from bids b where b.time_posted = a.time_posted and b.driver_id = a.driver_id) as num_bidders," \
                "(a.departure_time::timestamp(0) - CURRENT_TIMESTAMP::timestamp(0) - '30 minutes'::interval) as time_remaining" \
                " from advertisement a where a.departure_time > (CURRENT_TIMESTAMP + '30 minutes'::interval)"
        ad_list = db.session.execute(ad_list_query).fetchall()

        bid_list_query = "select date(a.departure_time) as date, a.departure_time::time(0) as time, a.from_place, " \
                         "a.to_place, a.num_passengers, b.price as bid_price," \
                         "(select max(price) from bids b1 where b1.time_posted = a.time_posted and b1.driver_id = a.driver_id) as highest_bid," \
                         "(SELECT count(*) from bids b1 where b1.time_posted = a.time_posted and b1.driver_id = a.driver_id) as num_bidders," \
                         "(a.departure_time::timestamp(0) - CURRENT_TIMESTAMP::timestamp(0) - '30 minutes'::interval) as time_remaining," \
                         "b.status " \
                         "from advertisement a JOIN bids b ON a.driver_id = b.driver_id and a.time_posted = b.time_posted " \
                         "where (a.departure_time > (CURRENT_TIMESTAMP + '30 minutes'::interval)) " \
                         "and b.passenger_id= '{}'".format(current_user.username)
        bid_list = db.session.execute(bid_list_query).fetchall()
        print(bid_list)
        print(ad_list)

        form = BidForm()
        if form.is_submitted():
            print("Bid amount: $", form.bidPrice.data)
            print("numPassengers entered: ", form.num_passengers.data)

        return render_template("home.html", current_user=current_user, ad_list=ad_list, bid_list=bid_list)
    else:
        return redirect("/login")


@view.route("/registration", methods=["GET", "POST"])
def render_registration_page():
    form = RegistrationForm()
    if form.validate_on_submit():
        username = form.username.data
        first_name = form.first_name.data
        last_name = form.last_name.data
        password = form.password.data
        phone_num = form.phone_number.data
        query = "SELECT * FROM app_user WHERE username = '{}'".format(username)
        exists_user = db.session.execute(query).fetchone()
        if exists_user:
            form.username.errors.append("{} is already in use.".format(username))
        else:
            query = "INSERT INTO app_user(username, first_name, last_name, password, phone_number) " \
                    "VALUES ('{}', '{}', '{}', '{}', '{}')"\
                .format(username, first_name, last_name, password, phone_num)
            db.session.execute(query)
            db.session.commit()
            form.message = "Register successful! Please login with your newly created account."
    return render_template("registration.html", form=form)


@view.route("/logout")
def logout():
    logout_user()
    return redirect("/login")


@view.route("/login", methods=["GET", "POST"])
def render_login_page():
    form = LoginForm()
    if form.is_submitted():
        print("username entered:", form.username.data)
        print("password entered:", form.password.data)
        print(form.validate_on_submit())
    if form.validate_on_submit():
        user = AppUser.query.filter_by(username=form.username.data).first()
        if user:
            # TODO: You may want to verify if password is correct
            if user.password == form.password.data:
                login_user(user)
                return redirect("/")
            else:
                form.password.errors.append("Wrong password!")
        else:
            form.username.errors.append("No such user! Please login with a valid username or register to continue.")
    return render_template("index.html", form=form)


@view.route("/scheduled", methods=["GET"])
def render_scheduled_page():
    if current_user.is_authenticated:
        return render_template("scheduled.html", current_user=current_user)
    else:
        return redirect("/login")


@view.route("/car-registration", methods=["GET","POST"])
def render_car_registration_page():
    if current_user.is_authenticated:
        if request.method == "POST":
            brand = request.form['brand']
            model = request.form['model']
            plate_num = request.form['plate-num']
            color = request.form['colour']
            if(brand == "" or model == "" or plate_num == "" or color == "") :
                # input fields are empty
                return render_template("car-registration.html", current_user=current_user, empty_error = True)
            else:
                print(brand)
                print(model)
                check_model_query = "SELECT * FROM model WHERE " \
                                "model.brand = '{}' AND model.name = '{}'".format(brand, model)
                check_model = db.session.execute(check_model_query).fetchall()
                if(len(check_model) != 0) :
                    # model exists in DB
                    # add plate number and color to car
                    # add car to owns
                    check_car_query = "SELECT * FROM car WHERE car.plate_number = '{}'".format(plate_num)
                    check_car = db.session.execute(check_car_query).fetchall()
                    if(len(check_car) != 0) :
                        # The car has been registered!
                        return render_template("car-registration.html", current_user=current_user, exist_car_error = True)
                    else:
                        add_car_query = "INSERT INTO car(plate_number, colours) " \
                            "VALUES ('{}', '{}')".format(plate_num, color)
                        db.session.execute(add_car_query)
                        db.session.commit()
                        add_owns_query = "INSERT INTO owns(driver_id, plate_number) " \
                                        "VALUES ('{}', '{}')".format(current_user.username, plate_num)
                        db.session.execute(add_owns_query)
                        db.session.commit()
                        return render_template("car-registration.html", current_user=current_user, success=True)
                else:
                    # model doesn't exist in DB
                    return render_template("car-registration.html", current_user=current_user, car_model_error=True)
        return render_template("car-registration.html", current_user=current_user)
    else:
        return redirect("/login")


@view.route("/create-advertisement", methods=["GET", "POST"])
def render_create_advertisement_page():
    if current_user.is_authenticated:
        car_model_list_query = "SELECT * FROM belongs WHERE belongs.plate_number in " \
                               "(SELECT plate_number FROM owns WHERE owns.driver_id = '{}')".format(current_user.username)
        car_model_list = db.session.execute(car_model_list_query).fetchall()
        print(car_model_list)
        max_passenger_query = "WITH X AS " \
                              "(SELECT * FROM belongs WHERE belongs.plate_number in " \
                               "(SELECT plate_number FROM owns WHERE owns.driver_id = '{}'))" \
                               "SELECT MAX(size) FROM model " \
                               "WHERE EXISTS (SELECT 1 FROM X WHERE X.brand = model.brand AND X.name = model.name)".format(current_user.username)
        max_passenger = db.session.execute(max_passenger_query).fetchall()
        print(max_passenger)
        return render_template("create-advertisement.html", current_user=current_user, car_model_list = car_model_list, max_passenger = max_passenger)
    else:
        return redirect("/login")


@view.route("/view-advertisement", methods=["GET"])
def render_view_advertisement_page():
    if current_user.is_authenticated:
        driver_ad_list_query = "SELECT date(a.departure_time) as date, a.departure_time::time(0) as time, a.from_place, a.to_place, " \
                "(SELECT price from bids b where b.time_posted = a.time_posted and b.driver_id = a.driver_id) as my_bid," \
                "(SELECT max(price) from bids b where b.time_posted = a.time_posted and b.driver_id = a.driver_id) as highest_bid," \
                "(SELECT count(*) from bids b where b.time_posted = a.time_posted and b.driver_id = a.driver_id) as num_bidders," \
                "(a.departure_time::timestamp(0) - CURRENT_TIMESTAMP::timestamp(0) - '30 minutes'::interval) as time_remaining," \
                "(SELECT status from bids b where b.time_posted = a.time_posted and b.driver_id = a.driver_id) as bid_status" \
                " from advertisement a where a.departure_time > (CURRENT_TIMESTAMP + '30 minutes'::interval)"
        driver_ad_list = db.session.execute(driver_ad_list_query).fetchall()
        
        driver_bid_list_query = "SELECT a.departure_time::time(0) as advertisement_num, " \
                "(SELECT passenger_id from bids b where b.time_posted = a.time_posted and b.driver_id = a.driver_id) as passenger_username," \
                "(SELECT price from bids b where b.time_posted = a.time_posted and b.driver_id = a.driver_id) as bid, a.num_passengers" \
                " from advertisement a where a.departure_time > (CURRENT_TIMESTAMP + '30 minutes'::interval)"
        driver_bid_list = db.session.execute(driver_bid_list_query).fetchall()
                
        return render_template("view-advertisement.html", current_user=current_user, driver_ad_list = driver_ad_list, driver_bid_list = driver_bid_list)
    else:
        return redirect("/login")


@view.route("/privileged-page", methods=["GET"])
@login_required
def render_privileged_page():
    return "<h1>Hello, {}!</h1>".format(current_user.first_name or current_user.username)

# @view.route("/submit-bid")
# def execute_bid():
#     form = BidForm()
#     if form.is_submitted:
#         print(form.no_passengers.data)
#         print(form.bidPrice.data)
#     return 'nothing'
