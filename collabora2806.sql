PGDMP         0    
            t        	   collabora    9.3.12    9.3.12     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �            1259    16408 	   questions    TABLE     o   CREATE TABLE questions (
    qid integer NOT NULL,
    qtext text,
    quid integer NOT NULL,
    note text
);
    DROP TABLE public.questions;
       public         boss    false            �          0    16408 	   questions 
   TABLE DATA               4   COPY questions (qid, qtext, quid, note) FROM stdin;
    public       boss    false    173   �       ^           2606    24594    questions_pk 
   CONSTRAINT     N   ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pk PRIMARY KEY (qid);
 @   ALTER TABLE ONLY public.questions DROP CONSTRAINT questions_pk;
       public         boss    false    173    173            _           2606    24619    questions_fk    FK CONSTRAINT     o   ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_fk FOREIGN KEY (quid) REFERENCES questionnaires(quid);
 @   ALTER TABLE ONLY public.questions DROP CONSTRAINT questions_fk;
       public       boss    false    173            �      x������ � �     