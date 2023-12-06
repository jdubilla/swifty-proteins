import express from 'express'
import authentication from './routes/authentication'

const app = express()
const port = 3000

app.use('/authentication', authentication)

app.listen(port, () => {
	return console.log(`Express is listening at http://localhost:${port}`);
})