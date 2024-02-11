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
exports.addUser = void 0;
const argon2_1 = __importDefault(require("argon2"));
const connectiondb_1 = require("./connectiondb");
const token_1 = require("../utils/token");
const addUser = (username, password) => __awaiter(void 0, void 0, void 0, function* () {
    const connection = (0, connectiondb_1.getConnection)();
    const hashedPassword = yield argon2_1.default.hash(password);
    try {
        const addUserQuery = 'INSERT INTO user (username, password) VALUES (?, ?);';
        const values = [username, hashedPassword];
        const createUserResult = yield new Promise((resolve, reject) => {
            connection.query(addUserQuery, values, (err, result) => {
                if (err) {
                    reject(new Error('Internal error, please try again later'));
                }
                else {
                    resolve(result);
                }
            });
        });
        const token = (0, token_1.generateJWT)(createUserResult.insertId);
        return token;
    }
    catch (error) {
        throw error;
    }
});
exports.addUser = addUser;
