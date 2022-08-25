from kafka import KafkaProducer

producer = KafkaProducer(key_serializer=str.encode, value_serializer=str.encode)

while (True):
    user_in = input("Enter message to send to kafka: ")
    if user_in == "quit":
        break
    producer.send("test1", key="prod2", value=user_in)
    producer.flush()

