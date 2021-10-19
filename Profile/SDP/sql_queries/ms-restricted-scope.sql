select
	case
		when count(*) > 0 then true
		else false
	end `has_services?`
from sdpid_service
where sdpid = 55562;
