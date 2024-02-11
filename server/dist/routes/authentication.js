"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const signup_1 = require("../controllers/signup");
const signin_1 = require("../controllers/signin");
const checkToken_1 = require("../controllers/checkToken");
const router = express_1.default.Router();
router.post('/signup', signup_1.signup);
router.post('/signin', signin_1.signin);
router.get('/checkToken', checkToken_1.checkToken);
exports.default = router;
