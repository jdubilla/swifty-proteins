import express from 'express'
import { test } from '../controllers/authentication';

const router = express.Router();

router.get('/', test)

export default router;