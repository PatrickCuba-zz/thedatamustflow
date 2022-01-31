select "resource"
, "status"
, "acquired_on"
, "type"
from utilities.table_locks
where to_date("acquired_on") = :daterange
and "status" = 'HOLDING'
