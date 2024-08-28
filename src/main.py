import os
import discord
from discord.ext import tasks, commands
from dotenv import load_dotenv
from aws_lambda_powertools import Logger

# Load env vars from .env
load_dotenv()

# Amazon CloudWatch Logs を使用して。
logger = Logger()

intents = discord.Intents.all()

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

    # ナイトコア猫のサーバない
    if not guild:
        print('ナイトコア猫のサーバない')
        logger.error({'エラー': 'ナイトコア猫のサーバない'})
        return

    role_twitchsub = guild.get_role(ROLE_TWITCHSUB_ID)
    role_booster = guild.get_role(ROLE_BOOSTER_ID)
    role_supporter = guild.get_role(ROLE_SUPPORTER_ID)

    # それぞれを一個ずつください。
    if None in [role_twitchsub, role_booster, role_supporter]:
        print('何か足りない。')
        logger.error({'エラー': '何か足りない。'})
        return

    for i, member in enumerate(guild.members):        
        has_role_twitchsub = role_twitchsub in member.roles
        has_role_booster = role_booster in member.roles
        変更 = ''
        サポート = None

        # memberはサポーターなの？
        # member is a supporter?
        if has_role_twitchsub or has_role_booster:
            サポート = True
            if role_supporter not in member.roles:
                await member.add_roles(role_supporter, reason=f'{member.name}のサポートに感謝します。')
                logger.info({'ユーザー名': {member.name}, '変更': '+', 'ロール':role_supporter})
                print(f'Added role SUPPORTER to {member.name}')
                変更 = '+'
        else:
            if role_supporter in member.roles:
                await member.remove_roles(role_supporter)
                logger.info({'ユーザー名': {member.name}, '変更': '-', 'ロール':role_supporter})
                member.add_roles(role_supporter, reason=f'{member.name}は最近ギフト…🥺')
                変更 = '-'
            
        print(f'{i},{(lambda is_サポート: "[^._.^]ﾉ彡" if is_サポート else "")(サポート)},{変更},{member.name}')

bot.run(os.environ['DISCORD_BOT_TOKEN'])