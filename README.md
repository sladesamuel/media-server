# Home Media Server

An automated setup for finding and downloading movies and shows locally, in a repeatable way that can be run on my local machine, or on a server.

## Prerequisites

The following must be installed to run the project.

1. [Docker Engine](https://docs.docker.com/engine/install/)
1. [Docker Compose](https://docs.docker.com/compose/install/)

## Getting started

The first time you pull down this project, you'll need to initialize it. To do this, simply run the `init.sh` file in the current directory. This will create a `.env` file containing some properties required by the service.

To run the service, run the following command from the terminal:

```sh
$ ./start.sh
```

This will spin up all services in Docker in the background. To stop, run:

```sh
$ ./stop.sh
```

Once running, you can access the web UI for each service using the following URLs:

- [Transmission](#transmission) → http://localhost:9091
- [Jackett](#jackett) → http://localhost:9117
- [Sonarr](#sonarr) → http://localhost:8989
- [Radarr](#radarr) → http://localhost:7878
- [Jellyfin](#jellyfin) → http://localhost:8096
- [Jellyseerr](#jellyseerr) → http://localhost:5056

Now you can follow the [configuration](#configuration) steps.

## Structure

Using this configuration by default expects the following folder structure to exist:

```
~/Videos/Movies
~/Videos/Shows
~/Videos/Downloads
```

> Note: This is based on a UNIX-based system, such as Linux.

## Configuration

### Transmission (Torrent Client)

- Open web UI: http://localhost:9091
- Confirm download folders are set to /downloads/complete and /downloads/incomplete (should be automatic from Docker env)
- (Optional) Set a username/password under Settings > Web to secure the UI
- Adjust speed limits or port forwarding as needed

### Jackett (Indexer Proxy)

Open: http://localhost:9117

- Configure the indexers you want (many public ones are available).
- Copy the **Torznab feed URL** from Jackett for each indexer.

### Sonarr (TV Show Manager)

Open: http://localhost:8989

- **Media Management > Root Folders:**
  Add `/media/Shows` as the root folder where Sonarr will place TV shows.
- **Download Clients:**
  - Add Transmission
  - Host: transmission (the Docker service name)
  - Port: 9091
  - Category: tv (make sure Transmission downloads tagged with this)
  - Leave username/password blank if you didn’t set any in Transmission
- **Indexers:**
  Add indexers (these are sites that provide torrent/nzb info). Some good public ones:
  - Rarbg (via Torznab)
  - Jackett (if you want a unified indexer proxy)
- **Profiles > Quality:**
  Use a profile like “HD-1080p” or create your own to avoid junk CAMs or low-quality releases.
- **Enable Completed Download Handling** so Sonarr moves and renames files after download.
- [Configure Download Client](#configure-download-client)
- [Add Indexers](#add-indexers)

### Radarr (Movie Manager)

Open: http://localhost:7878

- **Media Management > Root Folders:**
  Add `/media/Movies` as the root folder.
- **Download Clients:**
  Same as Sonarr but Category is movies.
- **Indexers & Profiles:**
  Same approach as Sonarr.
- Enable Completed Download Handling.
- [Configure Download Client](#configure-download-client)
- [Add Indexers](#add-indexers)

### Jellyfin (Media Library Manager)

Open: http://localhost:8096

- **Create your admin user**
  - Follow the setup wizard to create your first admin user account.
- **Add Media Libraries**
  - Go to Dashboard > Libraries > Add Media Library
  - Choose **Movies** for `~/Videos/Movies` → Set folder path inside container: `/media/Movies`
  - Choose **TV Shows** for `~/Videos/Shows` → Set folder path inside container: `/media/Shows`
  - Set appropriate library names (e.g., “Movies”, “TV Shows”)
  - Save your library and allow Jellyfin to scan media files.
- **Set Permissions**
  - Make sure your media files are readable by the Jellyfin user (usually handled by correct `PUID`/`PGID`).

### Jellyseerr (Request Manager)

Open: http://localhost:5056

Follow the steps in the setup wizard.

> Note that the jellyfin server will be running on `http://jellyfin:8096`, as it's running within the Docker network - Jellyseerr cannot see the machine's localhost.

### Configure Download Client

1. Open Radarr (http://localhost:7878) or Sonarr (http://localhost:8989).
1. Go to **Settings > Download Clients.**
1. Click **Add** and select **Transmission**.
1. Fill in the Transmission details:
  - **Host:** `transmission` (this is the Docker Compose service name)
  - **Port:** `9091`
  - **Username** and **Password**: Only if you set one in Transmission’s web UI (likely empty)
  - **Category**:
    - `movies` for Radarr
    - `tv` for Sonarr
      This helps Transmission tag downloads for each app.
1. Test the connection and save.

### Add Indexers

1. In Radarr/Sonarr, go to **Settings > Indexers.**
1. Click **Add > Torznab.**
1. Paste the Torznab feed URL from Jackett.
1. Add your Jackett API key (found in Jackett dashboard).
1. Test the connection and save.

