import express, { Request } from 'express';
import cors from 'cors';
import proxy from 'express-http-proxy';

const app = express();

app.use(cors());
app.use(express.json());

app.use(
  '/auth',
  proxy(process.env.USERS_MS_URL || 'http://localhost:3002', {
    proxyReqPathResolver: (req: Request) => {
      return `/auth${req.url}`;
    },
  })
);
app.use('/user', proxy(process.env.USERS_MS_URL || 'http://localhost:3002'));
app.use('/', proxy(process.env.CORE_MS_URL || 'http://localhost:3001'));

app.listen(3000, () => {
  console.log('Gateway is listening to Port 3000');
});
