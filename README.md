# Clan-wars & Tournaments Library

## Introduction

Hello, I made this library a while ago, and to be honest, it's quite useful when it comes to dealing with tournaments and clan-wars servers. Hence, I decided to make it public to everyone. 

**Note:** The library is mainly based on OOP **(Object-oriented programming)**. Therefore, you should have a little amount of experience before using it. Also, please if you notice any bugs or improvements let me know either by contacting me directly or by creating an issue through GitHub.

Discord: N3xT#0001

## Classes

This library provides you an easier way to deal with such scripts. It's made of 3 classes:

#### Core
This would be the heart of your script, dealing with clan-war state, played rounds, outputting notifications, and much more to implement if you think out of the box.

#### Clans
For the second part, which plays a critical role here. Clans, so instead of writing hundreds of codes to create clans, adding points, etcetera. It can be done with the provided functions instead.

#### Players
Last but not least. Players, I guess who doesn't deal with players when it comes to MTA. This class provides you a better way to deal with points and storing them, setting a clan to an individual. You also have to keep that in mind, points table **"PlayersData"** was never cleared, so you have to deal with that to prevent a memory leak.

## Usage

I made a little file called **main_server.lua**. You should find a few examples in there. And the rest is up to you!
