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
exports.verifyToken = exports.generateJWT = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
function generateJWT(userId) {
    const payload = {
        userId: userId,
        createdDate: Date()
    };
    const secretKey = process.env.SECRET_JWT;
    if (!secretKey) {
        throw new Error('Secret key undefined');
    }
    const token = jsonwebtoken_1.default.sign(payload, secretKey);
    return token;
}
exports.generateJWT = generateJWT;
function verifyToken(token, secretKey) {
    return __awaiter(this, void 0, void 0, function* () {
        console.log(token);
        console.log(secretKey);
        return new Promise((resolve, reject) => {
            jsonwebtoken_1.default.verify(token, secretKey, (err, user) => {
                if (err) {
                    reject(new Error("Invalid token"));
                }
                else {
                    resolve(user);
                }
            });
        });
    });
}
exports.verifyToken = verifyToken;
