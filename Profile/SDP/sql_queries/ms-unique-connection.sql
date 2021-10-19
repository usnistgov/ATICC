select
	case
		when count(distinct port) = count(port) then true
		else false
	end `unique?`
from service_gateway;
