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
* Baixe e execute ordersdb.jar do projeto [OrdersDB](https://github.com/gabrielbrub/ordersdb).
```
java -jar ordersdb.jar
 ```
* Crie o usuário 'OrdersManager'@'localhost' (sem senha) com grants no MySQL:

```
 create user 'OrdersManager'@'localhost' identified by '';
 grant select, insert, delete, update on ordersdb.* to 'OrdersManager'@'localhost';
 ```
 
## Capturas de Tela

<p float="left" align="middle" hspace="20"">
  <img src="https://i.imgur.com/yVjgyQT.jpg" height="740" width="360" />
  <img src="https://i.imgur.com/w1N3sxQ.jpg" height="740" width="360" /> 
</p>

## Feito com

* [Android Studio](https://developer.android.com/studio)

## Autor

* **Gabriel Rubião** - [gabrielbrub](https://github.com/gabrielbrub)

                                                                     
                                                                  
