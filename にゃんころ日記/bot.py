import os
import discord
from discord.ext import commands, tasks

TOKEN: str = os.environ['DISCORD_BOT_TOKEN']

# 環境変数からループ間隔を取得、デフォルトは24時間 / Get loop interval from env, default 24h
LOOP_HOURS = float(os.environ.get("BOT_LOOP_HOURS", 24))  

intents = discord.Intents.all()
bot = commands.Bot(command_prefix="!", intents=intents)

@bot.event
async def on_ready():
    print('hello world!!')
    if not auto_send_message.is_running():
        auto_send_message.start()

# 定期送信タスク / Scheduled message task
@tasks.loop(minutes=1)
async def auto_send_message():
    DISCORD_JOSHIROTENBURO_CHANNEL = int(os.environ['DISCORD_JOSHIROTENBURO_CHANNEL'])
    DISCORD_TWITCHCHAT_CHANNEL = int(os.environ['DISCORD_TWITCHCHAT_CHANNEL'])

    joshirotenburo_channel = bot.get_channel(DISCORD_JOSHIROTENBURO_CHANNEL)
    twitchchat_channel = bot.get_channel(DISCORD_TWITCHCHAT_CHANNEL)

    # チャンネルがTextChannelか確認 / Make sure channel is a TextChannel
    if isinstance(joshirotenburo_channel, discord.TextChannel):
        await joshirotenburo_channel.send("にゃん〜！!")
    if isinstance(twitchchat_channel, discord.TextChannel):
        await twitchchat_channel.send("やっほ〜！！")

bot.run(TOKEN)