import os
from supabase import create_client
from dotenv import load_dotenv

load_dotenv()
SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def upload_mp3_to_supabase(file_path, title, artist, image_url, url_lrc):
    try:
        file_name = os.path.basename(file_path)
        supabase.storage.from_("musics").upload(file_name, file_path)
        file_url = supabase.storage.from_("musics").get_public_url(file_name)
        data = {
            "title": title,
            "artist": artist,
            "file_url": file_url,
            "image_url": image_url,
            "url_lrc": url_lrc
        }
        supabase.table("songs").insert(data).execute()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":

    upload_mp3_to_supabase(
        file_path='.mp3',
        title='',
        artist='',
        image_url='',
        url_lrc='https://osroaycdopetvxchekvx.supabase.co/storage/v1/object/public/musics/lyrics/empty.lrc'
    )