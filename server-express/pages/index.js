import React, { useState, useEffect } from 'react'
import PropTypes from 'prop-types'
import io from 'socket.io-client'

const socketExpress = io('http://localhost:3600')
const socketFlask = io('http://localhost:3500')

const Index = () => {
  const [counterExpress, setCounterExpress] = useState(null)
  const [timerFlask, setTimeFlask] = useState(null)

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

  const handleOnClick = e => {
    socketExpress.emit('hello', 'Hello express')
  }

  const sendToFlaskSocket = e => {
    socketFlask.emit('hello', 'Hello flask')
  }

  const handleFlaskCounter = e => {
    socketFlask.emit('getcounter', 'Get counter')
  }

  return (
    <div>
      <p>{JSON.stringify(counterExpress)}</p>
      <button onClick={handleOnClick}>Send message to node socket</button>

      <p>{JSON.stringify(timerFlask)}</p>
      <button onClick={sendToFlaskSocket}>Send message to flask socket</button>
      <button onClick={handleFlaskCounter}>Get counter flask socket</button>
    </div>
  )
}

export default Index
