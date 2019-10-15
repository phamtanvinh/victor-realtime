import React, { useState, useEffect } from 'react'
import PropTypes from 'prop-types'
import io from 'socket.io-client'
import kafka from 'kafka-node'

const socketExpress = io('http://localhost:3600')
const socketFlask = io('http://localhost:3500')
// const kafkaClient = new kafka.KafkaClient()

const Index = () => {
  const [counterExpress, setCounterExpress] = useState(null)
  const [timerFlask, setTimeFlask] = useState(null)
  // const consumer = new kafka.Consumer(kafkaClient, [{ topic: 'test' }], {
  //   autoCommit: true
  // })

  useEffect(() => {
    // consumer.on('message', message => console.log(message))
  }, [])

  useEffect(() => {
    socketExpress.on('getcounter', respone => {
      setCounterExpress(respone)
    })
  }, [counterExpress])

  useEffect(() => {
    socketFlask.on('getcounter', respone => {
      setTimeFlask(respone)
    })
  }, [timerFlask])

  const sendToExpressSocket = e => {
    socketExpress.emit('hello', 'Hello express')
  }

  const sendToFlaskSocket = e => {
    socketFlask.emit('hello', 'Hello flask')
  }

  return (
    <div>
      <p>{JSON.stringify(counterExpress)}</p>
      <button onClick={sendToExpressSocket}>Send message to node socket</button>

      <p>{JSON.stringify(timerFlask)}</p>
      <button onClick={sendToFlaskSocket}>Send message to flask socket</button>
    </div>
  )
}

export default Index
