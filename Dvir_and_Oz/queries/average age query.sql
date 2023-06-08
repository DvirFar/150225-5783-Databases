select AVG(MONTHS_BETWEEN(sysdate, birthday) / 12) AS average_age
from liocohen.player;
