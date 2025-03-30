import express from 'express';
import helmet from 'helmet';

const app = express();

app.use(helmet());

app.get('/', (req, res) => {
  res.send('Hello World!');
});

const port = process.env.PORT || 3000;

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
