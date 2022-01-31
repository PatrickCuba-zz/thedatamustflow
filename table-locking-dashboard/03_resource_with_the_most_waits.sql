select "resource"
, "status"
, "transaction_started_on"
, "type"
from utilities.table_locks
where to_date("transaction_started_on") = :daterange
and "status" = 'WAITING'