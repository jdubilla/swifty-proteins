import express from 'express'
import { signup } from '../controllers/authentication';

const router = express.Router();

router.post('/signup', signup)

export default router;