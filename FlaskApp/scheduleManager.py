from __init__ import db

# Returns the upcoming pickups of the current user.
def getUpcomingPickups(driverID):
    query = \
        "SELECT r.ride_ID, a.departure_time, a.from_place, a.to_place, au.first_name, au.phone_number, r.status "\
        "FROM Ride AS r INNER JOIN Bids AS b "\
        "ON (r.passenger_ID, r.time_posted, r.driver_ID) = (b.passenger_ID, b.time_posted, b.driver_ID) "\
        "INNER JOIN Advertisement AS a ON (r.time_posted, r.driver_ID) = (a.time_posted, a.driver_ID) "\
        "INNER JOIN App_User AS au ON r.passenger_ID = au.username "\
        "WHERE (r.status = 'pending' OR r.status = 'ongoing') AND r.driver_id = '{}'".format(driverID)
    upcomingPickups = db.session.execute(query).fetchall()
    # print(upcomingPickups)
    return upcomingPickups

# Returns true IFF username is a driver.
def isDriver(username):
    query = "SELECT * FROM Driver WHERE username = '{}';".format(username)
    result = db.session.execute(query).fetchone()
    return True if result is not None else False
