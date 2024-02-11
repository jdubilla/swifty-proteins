"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.signin = void 0;
const argon2_1 = __importDefault(require("argon2"));
const userExist_1 = require("../services/userExist");
const token_1 = require("../utils/token");
function checkParams(username, password) {
    if (!username || !password) {
        throw new Error("Missing required params");
    }
}
const signin = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { username, password } = req.body;
        checkParams(username, password);
        const user = yield (0, userExist_1.userExist)(username);
        if (!user) {
            throw new Error("Username don\'t exist");
        }
        const storedPassword = user.password;
        const passwordMatch = yield argon2_1.default.verify(storedPassword, password);
        if (!passwordMatch) {
            throw new Error("Bad password");
        }
        const token = (0, token_1.generateJWT)(user.id);
        return res.json({ token: token });
    }
    catch (error) {
        return res.status(500).json({ error: error.message });
    }
});
exports.signin = signin;
