import React, { useState, useEffect } from 'react'
import PropTypes from 'prop-types'
import io from 'socket.io-client'

const socketExpress = io('http://localhost:3600', { autoConnect: true })
const socketFlask = io('http://localhost:3500', { autoConnect: false })

const Index = () => {
  const [counterExpress, setCounterExpress] = useState(null)
  const [timerFlask, setTimeFlask] = useState(null)
  const [kafkaMessage, setKafkaMessage] = useState(null)

  useEffect(() => {
    socketExpress.on('getcounter', respone => {
      setCounterExpress(respone)
    })

    socketExpress.on('kafka-message', message => {
      const enc = new TextDecoder()
      setKafkaMessage(enc.decode(message))
    })

    socketFlask.on('getcounter', respone => {
      setTimeFlask(respone)
    })
  }, [counterExpress, kafkaMessage, timerFlask])

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
      <p>Message from kafka: {kafkaMessage}</p>
    </div>
  )
}

export default Index
