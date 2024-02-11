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
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkToken = void 0;
const token_1 = require("../utils/token");
const checkToken = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const token = String(req.query.token);
        const secretKey = process.env.SECRET_JWT;
        if (!token) {
            throw new Error("Missing required params");
        }
        if (!secretKey) {
            throw new Error("Secret key undefined");
        }
        const user = yield (0, token_1.verifyToken)(token, secretKey);
        return res.status(200).json(user);
    }
    catch (error) {
        console.log(error.message);
        return res.status(500).json({ error: error.message });
    }
});
exports.checkToken = checkToken;
