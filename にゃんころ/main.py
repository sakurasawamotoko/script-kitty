import os
import discord
from discord.ext import commands
from dotenv import load_dotenv
from aws_lambda_powertools import Logger
from discord import Guild, Role

load_dotenv()

# Amazon CloudWatch Logs を使用して。
# Use Amazon CloudWatch Logs.
logger = Logger()

intents = discord.Intents.all()
bot = commands.Bot(command_prefix='!', intents=intents)

TOKEN: str = os.environ['DISCORD_BOT_TOKEN']
GUILD_ID: int = int(os.environ['DISCORD_GUILD_ID'])
ROLE_ネコ_NEKO_BADGE_ID: int = int(os.environ['DISCORD_ROLE_NEKOBAJI'])
def ネコバッジ受領者_NEKO_BADGE_RECIPIENTS() -> list[int]:
    return [
        int(os.environ['DISCORD_ROLE_DISCORDBOOSTER']),
        int(os.environ['DISCORD_ROLE_TWITCHSUB']),
        int(os.environ['DISCORD_ROLE_KASUTO']),
        int(os.environ['DISCORD_ROLE_SEITOKAIYAKUIN']),
        int(os.environ['DISCORD_ROLE_GAKKYUIIN']),
        int(os.environ['DISCORD_ROLE_MANGAKA'])
    ]
    
ネコバッジ受領者_neko_badge_recipients = ネコバッジ受領者_NEKO_BADGE_RECIPIENTS()

@bot.event
async def on_ready():
    guild: Guild | None = bot.get_guild(GUILD_ID)
    if guild is None:
        logger.error({'エラー': 'ナイトコアネコのサーバない'})
        print('ナイトコアネコのサーバない')
        return

    ネコバッジ_role: Role | None = guild.get_role(ROLE_ネコ_NEKO_BADGE_ID)
    if ネコバッジ_role is None:
        logger.error({'エラー': 'ネコバッジのロールが存在しません'})
        print('ネコバッジのロールが存在しません')
        return

    # サポーターロールを動的に取得
    # Fetch supporter roles dynamically
    supporter_roles: list[Role | None] = [guild.get_role(rid) for rid in ネコバッジ受領者_neko_badge_recipients]
    missing_roles: list[Role | None] = [guild.get_role(rid) for rid, role in zip(ネコバッジ受領者_neko_badge_recipients, supporter_roles) if role is None]
    if missing_roles:
        logger.error({'エラー': f'Missing supporter roles: {missing_roles}'})
        print(f'何か足りない: {missing_roles}')
        return

    # メンバーを反復処理
    # Iterate members
    for member in guild.members:
        is_supporter = any(r in member.roles for r in supporter_roles)
        
        if is_supporter and ネコバッジ_role not in member.roles:
            await member.add_roles(ネコバッジ_role, reason=f'{member.name} に ネコバッジを付与')
            logger.info({'ユーザー名': member.name, '変更': '+', 'ロール': ネコバッジ_role.name})
            print(f'Added {ネコバッジ_role.name} to {member.name}')
        elif not is_supporter and ネコバッジ_role in member.roles:
            await member.remove_roles(ネコバッジ_role, reason=f'{member.name} の ネコバッジを削除')
            logger.info({'ユーザー名': member.name, '変更': '-', 'ロール': ネコバッジ_role.name})
            print(f'Removed {ネコバッジ_role.name} from {member.name}')

    print('ネコバッジの同期が完了しました。')
bot.run(TOKEN)