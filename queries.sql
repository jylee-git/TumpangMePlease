-- Getting the list of advertisements
create view as active_advertisements
select date(a.departure_time) as date, a.departure_time::time(0) as time, a.from_place, a.to_place, a.num_passengers,
       (select max(price) from bids b where b.time_posted = a.time_posted and b.driver_id = a.driver_id) as highest_bid,
       (SELECT count(*) from bids b where b.time_posted = a.time_posted and b.driver_id = a.driver_id) as num_bidders,
       (a.departure_time::timestamp(0) - CURRENT_TIMESTAMP::timestamp(0) - '30 minutes'::interval) as time_remaining
from advertisement a
where (a.departure_time > (CURRENT_TIMESTAMP + '30 minutes'::interval))

-- Getting the user's list of bids
select date(a.departure_time) as date, a.departure_time::time(0) as time, a.from_place, a.to_place, a.num_passengers,
       b.price as bid_price,
       (select max(price) from bids b1 where b1.time_posted = a.time_posted and b1.driver_id = a.driver_id) as highest_bid,
       (SELECT count(*) from bids b1 where b1.time_posted = a.time_posted and b1.driver_id = a.driver_id) as num_bidders,
       (a.departure_time::timestamp(0) - CURRENT_TIMESTAMP::timestamp(0) - '30 minutes'::interval) as time_remaining,
       status
from advertisement a JOIN bids b ON a.driver_id = b.driver_id and a.time_posted = b.time_posted
where (a.departure_time > (CURRENT_TIMESTAMP + '30 minutes'::interval))
      and b.passenger_id = '{}'.format(current_user.username)
