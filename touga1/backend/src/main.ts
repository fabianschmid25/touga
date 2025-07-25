import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import * as morgan from 'morgan';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Loggt jede eingehende HTTP‑Anfrage in der Konsole
  app.use(morgan('dev'));

  app.enableCors();
  app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
  await app.listen(3000, '0.0.0.0');
  console.log('🚀 Backend läuft auf http://0.0.0.0:3000');
}
bootstrap();
