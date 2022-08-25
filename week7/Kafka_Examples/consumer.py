from kafka import KafkaConsumer

consumer = KafkaConsumer("test1")

for msg in consumer:
    print(msg.key if msg.key == None else msg.key.decode("utf-8"), msg.value.decode("utf-8"))