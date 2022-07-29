import mysql.connector
import mysql_config as c

cnx = mysql.connector.connect(user=c.user, password=c.password, host=c.host, database="220711_w2")

cursor = cnx.cursor()

query = "SELECT * FROM animals"

cursor.execute(query)

for record in cursor:
    print(record)

cursor.close()
cnx.close()