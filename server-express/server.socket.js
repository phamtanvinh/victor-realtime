import express from 'express'
import http from 'http'
import socketIO from 'socket.io'

const port = process.env.PORT || 3600
let interval
let counter = 0

const app = express()
app.get('/', (req, res) => {
  res.send({ respone: 'I am alive' }).status(200)
})

const server = http.createServer(app)

const io = socketIO(server)

io.on('connect', socket => {
  console.log('New client connected')
  if (interval) clearInterval(interval)

  interval = setInterval(() => {
    counter += 1
    socket.emit('getcounter', counter)
  }, 1000)

  socket.on('hello', msg => {
    console.log(msg)
  })
  
  socket.on('disconnect', () => console.log('Client disconnected'))
})
server.listen(port, err => {
  if (err) throw err

  console.log(`> Ready on http://localhost:${port}`)
})
