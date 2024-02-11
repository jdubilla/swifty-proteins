"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const dotenv_1 = __importDefault(require("dotenv"));
const authentication_1 = __importDefault(require("./routes/authentication"));
const cors_1 = __importDefault(require("cors"));
const connectiondb_1 = require("./services/connectiondb");
const app = (0, express_1.default)();
const port = 3000;
dotenv_1.default.config();
(0, connectiondb_1.createConnection)();
app.use((0, cors_1.default)());
app.use(express_1.default.json());
app.use('/authentication', authentication_1.default);
app.listen(port, () => {
    return console.log(`Express is listening at http://localhost:${port}`);
});
