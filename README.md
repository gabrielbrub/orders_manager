# Orders Manager

Aplicativo para gerenciamento de encomendas em Flutter. 

### Pré-requisitos

```
Flutter
JRE 1.8
MySQL 8
```

## Uso

* Altere as constantes IP_ADRESS e PORT em orders_manager\lib\services\networking.dart

E use o Docker Compose na raiz do projeto [OrdersDB](https://github.com/gabrielbrub/ordersdb).

```
docker-compose up
 ```
 
 Ou:

* Crie o usuário 'OrdersManager'@'localhost' (sem senha) com grants no MySQL:

```
 create user 'OrdersManager'@'localhost' identified by '';
 grant select, insert, delete, update on ordersdb.* to 'OrdersManager'@'localhost';
 ```
 * Baixe e execute ordersdb-0.0.1-SNAPSHOT.jar do projeto [OrdersDB](https://github.com/gabrielbrub/ordersdb).
```
java -jar ordersdb-0.0.1-SNAPSHOT.jar
 ```
 
## Capturas de Tela

<p float="left" align="middle" hspace="20"">
  <img src="https://i.imgur.com/sXgp5wv.jpg" height="740" width="360" />
  <img src="https://i.imgur.com/FM5sM7z.jpg" height="740" width="360" /> 
</p>

## Feito com

* [Android Studio](https://developer.android.com/studio)

## Autor

* **Gabriel Rubião** - [gabrielbrub](https://github.com/gabrielbrub)

                                                                     
                                                                  
