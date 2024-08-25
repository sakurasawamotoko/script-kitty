import json
import os
import discord
from discord.ext import tasks, commands
from dotenv import load_dotenv
from time import sleep

# Load env vars from .env
load_dotenv()

intents = discord.Intents.all()
#intents.members = True  # Enable member intents

# Initialize bot with command prefix and intents
bot = commands.Bot(command_prefix='!', intents=intents)

# Load environment variables
TOKEN = os.environ['DISCORD_BOT_TOKEN']
GUILD_ID = int(os.environ['DISCORD_GUILD_ID'])
ROLE_TWITCHSUB_ID = int(os.environ['DISCORD_ROLE_DISCORD_BOOSTER_ID'])
ROLE_BOOSTER_ID = int(os.environ['DISCORD_ROLE_TWITCH_SUB_ID'])
ROLE_SUPPORTER_ID = int(os.environ['DISCORD_ROLE_SUPPORTERS_ID'])

@bot.event
async def on_ready():
    guild = bot.get_guild(GUILD_ID)

    if guild is None:
        print("Guild not found")

    role_twitchsub = guild.get_role(ROLE_TWITCHSUB_ID)
    role_booster = guild.get_role(ROLE_BOOSTER_ID)
    role_supporter = guild.get_role(ROLE_SUPPORTER_ID)

    if None in [role_twitchsub, role_booster, role_supporter]:
        print("One or more roles not found")

    for member in guild.members:
        print(f'今：{member.name}')
        has_role_twitchsub = role_twitchsub in member.roles
        has_role_booster = role_booster in member.roles

        if has_role_twitchsub or has_role_booster:
            if role_supporter not in member.roles:
                await member.add_roles(role_supporter, reason=f"in recognition of {member.name}'s support")
                print(f"Added role SUPPORTER to {member.name}")
        else:
            if role_supporter in member.roles:
                await member.remove_roles(role_supporter)
                member.add_roles(role_supporter, reason=f"{member.name} is no longer a supporter 🥺")
                
bot.run(os.environ['DISCORD_BOT_TOKEN'])