import sys, argparse, datetime
from kafka import SimpleProducer, KafkaClient

parser = argparse.ArgumentParser()
parser.add_argument('--broker-list', help='')
parser.add_argument('--topic', help='')
parser.add_argument('--file', help='')
args = parser.parse_args()
print(args)


kafka = KafkaClient("localhost:9092")
producer = SimpleProducer(kafka)

file = open(args.file, 'r')
i = 0
last_line = ""
start = datetime.datetime.now() 
prev = start
for line in file:
    last_line = line.replace("\n", "")
    producer.send_messages(args.topic,last_line)
    i = i+1    
    if (i%1000 == 0):
        current = datetime.datetime.now() 
        print("{0:>9}th message sent at {1:6.2f} rate, {2:4d} sec elapsed => {3}".format(i, 
                      1000.0/(current - prev).total_seconds(), int((current - start).total_seconds()), last_line[:100]+"..."))
        prev = current

print("Total: {0} messages are sent".format(i))    
 

