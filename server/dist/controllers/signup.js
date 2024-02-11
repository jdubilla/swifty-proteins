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
exports.signup = void 0;
const userExist_1 = require("../services/userExist");
const addUser_1 = require("../services/addUser");
function checkPassword(password, confPassword) {
    const regex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]+$/;
    if (password !== confPassword) {
        throw new Error("Passwords must be sames");
    }
    if (password.length < 6 || !regex.test(password)) {
        throw new Error("Bad password");
    }
}
function checkParams(username, password, confPassword) {
    if (!username || !password || !confPassword) {
        throw new Error("Missing required params");
    }
    if (username.length <= 3 || username.length > 15) {
        throw new Error("Bad username");
    }
    checkPassword(password, confPassword);
}
const signup = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { username, password, confPassword } = req.body;
        checkParams(username, password, confPassword);
        if (yield (0, userExist_1.userExist)(username)) {
            return res.status(409).json({ error: "Username is already taken" });
        }
        const token = yield (0, addUser_1.addUser)(username, password);
        console.log(token);
        res.status(200).json({ token: token });
    }
    catch (error) {
        return res.status(500).json({ error: error.message });
    }
});
exports.signup = signup;
