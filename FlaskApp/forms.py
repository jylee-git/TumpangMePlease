from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, DecimalField, SelectField, IntegerField
from wtforms.validators import InputRequired, ValidationError


def is_valid_name(form, field):
    if not all(map(lambda char: char.isalpha() or char.isnumeric(), field.data)):
        raise ValidationError('This field should only contain alphanumerics!')


def is_valid_phone_number(form, field):
    if not all(map(lambda char: char.isnumeric(), field.data)):
        raise ValidationError('This field should only contain numerics!')

def is_valid_bidding_price(form, field):
    if not int(field.data) > 0.0:
        raise ValidationError('Please enter a valid bidding price!')


def agrees_terms_and_conditions(form, field):
    if not field.data:
        raise ValidationError('You must agree to the terms and conditions to sign up')


class RegistrationForm(FlaskForm):
    username = StringField(
        label='Username',
        validators=[InputRequired(), is_valid_name],
        render_kw={'placeholder': 'Username'}
    )
    first_name = StringField(
        label='First Name',
        validators=[InputRequired(), is_valid_name],
        render_kw={'placeholder': 'First Name'}
    )
    last_name = StringField(
        label='Last name',
        validators=[InputRequired(), is_valid_name],
        render_kw={'placeholder': 'Last Name'}
    )
    phone_number = StringField(
        label='Phone Number',
        validators=[InputRequired(), is_valid_phone_number],
        render_kw={'placeholder': 'Phone Number'}
    )
    password = PasswordField(
        label='Password',
        validators=[InputRequired()],
        render_kw={'placeholder': 'Password'}
    )


class LoginForm(FlaskForm):
    username = StringField(
        label='Username',
        validators=[InputRequired()],
        render_kw={'placeholder': 'Username', 'class': 'input100'}
    )
    password = PasswordField(
        label='Password',
        validators=[InputRequired()],
        render_kw={'placeholder': 'Password', 'class': 'input100'}
    )

######
# for bid feature
######
class BidForm(FlaskForm):
    bidPrice = DecimalField(
        label='Bidding Price',
        validators=[InputRequired(), is_valid_bidding_price],
        render_kw={'placeholder': 'Bidding price'}
    )
    no_passengers = IntegerField(
        label='Number of Passengers',
        validators=[InputRequired()],
        render_kw={'placeholder': 'Number of Passengers'}
    )
