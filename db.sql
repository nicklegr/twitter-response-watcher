create user twitter_response_watcher password 'twitter_response_watcher';

create table users (
	id serial primary key,

	user_id bigint unique,
	screen_name varchar(15)
);
grant all on users to twitter_response_watcher;
grant update on sequence users_id_seq to twitter_response_watcher;

create table user_infos (
	id serial primary key,

	user_id integer references users,
	friends_count integer,
	followers_count integer,
	statuses_count integer,
	listed_count integer,

	created_at timestamp(0)
);
grant all on user_infos to twitter_response_watcher;
grant update on sequence user_infos_id_seq to twitter_response_watcher;

CREATE INDEX "created_at" ON user_infos USING BTREE ("created_at")
