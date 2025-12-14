# bot.py
import os
import discord
from discord.ext import commands

TOKEN: str = os.environ['DISCORD_BOT_TOKEN']

intents = discord.Intents.default()
bot = commands.Bot(command_prefix="!", intents=intents)

@bot.event
async def on_ready():
    print('hello world!!!!')

bot.run(TOKEN)
