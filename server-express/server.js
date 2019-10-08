import express from 'express'
import next from 'next'

const port = parseInt(process.env.PORT) || 3000
const dev = process.env.NODE_ENV !== 'production'

const app = next({ dev })
app.prepare().then(() => {
  const server = express()

  server.get('/', (req, res)=>{
    return app.render(req, res, '/', req.query)
  })

  server.listen(port, err => {
    if (err) throw err
    return console.log(`> Ready for http://localhost:${port}`)
  })
})
