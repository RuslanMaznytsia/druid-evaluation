#!/bin/sh
exec scala "$0" "$@"
!#

import java.util.Properties
import org.apache.kafka.clients.producer.{KafkaProducer, ProducerRecord}

val file = sc.textFile("file:///Users/ytaras/Projects/other/kafka_join/perf_dump.txt")
val noHeader = res2.zipWithIndex.filter { _._2 != 0 }.map(_._1)

val props = new Properties()
props.put("bootstrap.servers", "localhost:9092")
props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer")
props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer")

val topic = "string_topic"
val producerRecords = noHeader.map(x => new ProducerRecord[String, String](topic, x))

producerRecords.foreachPartition { partition =>
      val producer = new KafkaProducer[String, String](props)
      partition.foreach(producer.send)
      producer.flush
      producer.close
}