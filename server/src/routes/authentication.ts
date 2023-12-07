import express from 'express'
import { signup } from '../controllers/signup';
import { signin } from '../controllers/signin';
import { checkToken } from '../controllers/checkToken';

const router = express.Router();

router.post('/signup', signup)
router.post('/signin', signin)
router.get('/checkToken', checkToken)

export default router;