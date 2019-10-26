from __init__ import db


def get_outstanding_payment_ride_id(passenger_id):
    query = "SELECT ride_id FROM Ride WHERE passenger_id = '{}' and status = 'completed' and is_paid = false".format(passenger_id)

    ride_id_of_outstanding_payment = db.session.execute(query).fetchone()

    return ride_id_of_outstanding_payment

