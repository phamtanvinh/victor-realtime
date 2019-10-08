import React, { useState, useEffect } from 'react'
import PropTypes from 'prop-types'
import io from 'socket.io-client'

const socket = io('http://localhost:3500')

const Index = () => {
  const [data, setData] = useState(null)

  socket.on('connect', () => {
    socket.on('stream', data => {
      setData(data)
    })
  })

  const handleOnClick = e => {
    socket.emit('click', 'Client message')
  }

  return (
    <div>
      <p>{JSON.stringify(data)}</p>
      <button onClick={handleOnClick}>Send messages</button>
    </div>
  )
}

export default Index
