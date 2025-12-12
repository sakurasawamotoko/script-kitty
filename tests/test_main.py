import sys
import os

def test_import_discord():
    try:
        import discord
        import dotenv
    except ImportError as e:
        assert False, f"インポートに失敗しました: {e}"
