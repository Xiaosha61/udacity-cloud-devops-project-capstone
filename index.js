const Koa = require('koa');
const app = new Koa();
const PORT = 3000;

app.use(async ctx => {
    console.log(`Received ${ctx.method} request for: ${ctx.path}.`);
    switch (ctx.path) {
    case "/env":
        ctx.body = process.env;
        break;
    default:
        ctx.body = "Welcome to my dummy node service.";
        break;
    }
});

app.listen(PORT, () => {
    debugger;
    console.log(`Server starts at port ${PORT}...`);
});
