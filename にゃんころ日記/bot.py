# bot.py
import os
import discord
from discord.ext import commands

TOKEN = os.environ.get("DISCORD_BOT_TOKEN")  # We'll store this in GitHub Actions / AWS Secrets

intents = discord.Intents.default()
bot = commands.Bot(command_prefix="!", intents=intents)

@bot.event
async def on_ready():
    print(f"{bot.user.name} is online!")

bot.run(TOKEN)
