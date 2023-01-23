# Chapter02-ブール算術

## インデックス
* [概要](#overview)
* [クロック](#clock)
* [フリップフロップ](#flip-flop)
* [レジスタ](#register)
* [メモリ](#memory)

<a id="overview"></a>

## 概要
* 1章と2章で構築した論理演算や算術演算の回路は、すべて **組み合わせ回路（combinational circuit）** と呼ばれる. 組み合わせ回路は、入力値の組み合わせだけによって関数の値が決定する. 組み合わせ回路は、重要な処理（ALUなど）を行うことができるが、**状態を保つ** ことはできない.
* 時間が経過してもデータを記憶することのできる記憶素子は、**順序回路（sequential circuit）** から構築することができる.
* 記憶素子を実装する作業は複雑な技法であり、同期、クロッキング、フィードバックループなどが関係してくる.
* **フリップフロップ（flip-flop）** と呼ばれる下位レベルの順序回路を用いれば、この複雑さフリップフロップの中に押し込めることができる.
* 本章では、フリップフロップをプリミティブな構成要素として用いて、コンピュータで使用される記憶装置すべて（2値素子、レジスタ、メモリ、カウンタ）を実装する. これらの回路を作り終えれば、コンピュータ全体を構築するために必要な回路がすべて出揃ったことになる.
<br />

<a id="clock"></a>

## クロック
* クロックとは
	* コンピュータでは、継続的に変化する信号をマスタクロックが送信することによって時間の経過を表現する. 実際のハードウェアにおける実装は、オシレーターに基づくのが一般的である.
	* オシレーターは、2つのフェーズ（0/1、low/high、tick/tockなどラベル付けされる）を絶え間なく行き来する. tickの始まりから次のtockの終わりまでに経過した時間を **周期（cycle）** と呼ぶ. このクロックの1周期がタイムユニット（単位時間）としてモデル化される.
	* 現在のクロックフェーズ（tickまたはtock）は、2値信号によって表すことができる.
	* ハードウェアの回路網を使用して、この信号はプラットフォームの隅から隅まで、すべての順序回路に送られる.
* [オシレーターとは](https://www.marubun.co.jp/technicalsquare/8950/)
	* クロックとは、タイミングを作るデバイスである.
	* プロセッサ・デジタル論理回路は、クロック同期で設計されており、1クロック単位で処理を実行する.
	* 固有の周期（周波数）をもった振り子のことをクロック製品では、共振器（Resonator）と呼ぶ. 共振器には、セラミック共振子、水晶振動子、SAW共振子などがあり、コンピュータ回路では水晶振動子が使用される.
	* 振り子を振動させ始めることと、振動を持続させるための回路のことをクロック製品では、**発振回路（Oscillator Circuit）** と呼ぶ.
	* 共振器と発振回路を1パッケージに収納した製品を **発振器（Osillator）** と呼ぶ.
<br />

<a id="flip-flop"></a>

## フリップフロップ
* フリップフロップとは
	* コンピュータで使用される順序回路の中で、最も基本となる回路.
	* 本書で扱うD型フリップフロップ（DEF）のインターフェースは、1ビットのデータ入力と1ビットのデータ出力である. さらに、DEFにはクロック入力があり、このクロック入力にはマスタクロックからの信号が絶えず送られる. データ入力とクロック入力が合わさることで、DEFは「時間に基づく振る舞い」が可能になる（$out(t) = in(t-1)$）.
	* DEFは、1つ前のタイムユニットの入力値を出力しているだけである.
* [フリップフロップの種類](https://engineer-education.com/sequential-circuit_flip-flop/#:~:text=%E3%83%95%E3%83%AA%E3%83%83%E3%83%97%E3%83%95%E3%83%AD%E3%83%83%E3%83%97%E3%81%AF%E3%80%81%E6%A7%8B%E9%80%A0%E3%81%A8,%E3%81%AA%E3%81%A9%E3%81%AE%E7%A8%AE%E9%A1%9E%E3%81%8C%E3%81%82%E3%82%8A%E3%81%BE%E3%81%99%E3%80%82)
	* 内部に記憶回路と同期回路を備え、入力信号の組み合わせだけで出力が決まらない論理回路を **順序回路** と呼ぶ.
	* フリップフロップには、構造と機能によって、RS型、JK型、D型、T型などの種類がある.
* [D型フリップフロップとは](https://engineer-education.com/sequential-circuit_flip-flop/#:~:text=%E3%83%95%E3%83%AA%E3%83%83%E3%83%97%E3%83%95%E3%83%AD%E3%83%83%E3%83%97%E3%81%AF%E3%80%81%E6%A7%8B%E9%80%A0%E3%81%A8,%E3%81%AA%E3%81%A9%E3%81%AE%E7%A8%AE%E9%A1%9E%E3%81%8C%E3%81%82%E3%82%8A%E3%81%BE%E3%81%99%E3%80%82)
	* D型フリップフロップは、D=1が入力されると1を記憶して1を出力し、D=0が入力されると0を記憶して0を出力するフリップフロップである.
	* D型フリップフロップは、他のフリップフロップと異なり、出力を決めるときに内部に記憶している現在の状態に依存せずに、入力だけから決まるという特徴がある.
	* 名称のDは、このフリップフロップをクロック波形に同期させて動作するように構成した時に、1クロック遅れて出力されることを表す **Delay** を取って「D型フリップフロップ」と呼ぶ.
<br />

<a id="register"></a>

## レジスタ
* レジスタとは
	* レジスタとは、データを格納したり、呼び出したりすることができる記憶装置である.
	* レジスタは、伝統的なストレージの振る舞いである$out(t) = out(t-1)$を実現する.
	* 多ビットのレジスタは、1ビットレジスタを必要な数だけ揃えて、それを配列上に並べて構築することができる. 多ビットのレジスタ設計では、幅（保持すべきビットの数）をパラメータとして考えなければならない. このパラメータの値は、16、32、64などの数字が用いられる.
	* 多ビットのレジスタの持つ値は、**ワード（word）** と呼ばれる.
	* [論理回路においては、フリップフロップなどにより状態を保持する装置をレジスタと呼ぶ. コンピュータにおいては、コンピュータのプロセッサ（CPU）などが内蔵する記憶回路で、制御装置や演算装置や実行ユニットに直結した、操作に要する速度が最速の比較的少量のものを指す.](https://ja.wikipedia.org/wiki/%E3%83%AC%E3%82%B8%E3%82%B9%E3%82%BF_(%E3%82%B3%E3%83%B3%E3%83%94%E3%83%A5%E3%83%BC%E3%82%BF))
* レジスタの実装課題
	* DEFの出力を単に入力に送信するだけでは、レジスタを実装することはできない. 
	* 新しいデータの値をこの回路に読み込む方法がない. どのタイミングでinワイヤからのデータを読み込み、どのタイミングでoutワイヤからのデータを読み込むのかということをDEFに指示する方法がないからである.
	* 一般的に回路設計において、内部ピンの入力数は1にしなければならない.
* レジスタの実装課題の解決方法
	* 回路設計にマルチプレクサを導入する.
	* マルチプレクサへの「選択ビット（select bit）」は、レジスタ回路への「読み込みビット（load bit）」の役割を担うことができる.
	* もしレジスタに新しい値を保持させたいならば、その新しい値を入力inに入れ、「読み込みビット」であるloadに1を設定すればよい. また、もし内部の値をレジスタに保持させたいならば、loadビットを0にすればよい.
<br />

<a id="memory"></a>

## メモリ
* レジスタをたくさん積み重ねることで、**RAM（Random Access Memory）ユニット** を構築することができる.
* 「ランダムアクセスメモリ」という名前の由来は、ランダムに選ばれたワードに対して、そのワードが位置する場所に制限を受けることなく、書き込み/読み込みができる、ということから来ている. メモリ中のすべてのワードは、その物理的に存在する場所に関係なく、同じ時間で直接アクセスできなければならない.
* そのような要求を満たすためには、最初にRAMの各ワード（これはn個のレジスタにより構成される）に対して、他とは重複しないユニークな番号（0からn-1までの間の整数）を **アドレス** として割り当てる. 次に、n個のレジスタ配列を構築するのに加えて、jという数に対して、アドレスがj番目のレジスタを個別に選択することができる論理ゲートを構築する. ここで、「アドレス」とは物理的な意味でのアドレス（所在地）ではない.
* RAM回路は、「直接アクセスロジック（direct access logic）」を備えることにより、論理的な意味でのアドレスが実現される.
* RAMは、データ入力、アドレス入力、ロードビットの3つの入力を受け取る. アドレス入力によって、現時刻において、RAMのどのレジスタにアクセスするかを指定する. メモリ操作が読み込みの場合（load=0）、選択されたレジスタの値が直ちに出力される. メモリ操作が書き込みの場合（load=1）、次のサイクルで、選択されたメモリのレジスタに値が送られる.
* RAMを設計する場合、パラメータとして、**幅** と **サイズ** を指定する必要がある. 幅は各ワードの幅であり、サイズはRAMに存在するワードの個数である. 現代の一般的なコンピュータでは、32もしくは64ビット幅のRAMを用いる. サイズは百万を超える.
<br />

<a id="reference"></a>

## 実装リファレンス
* [セキュリティ・キャンプ キャンパー育成枠の活動録前編](https://genkai-io.hatenablog.jp/entry/2018/12/05/102520)
* [セキュリティ・キャンプ キャンパー育成枠の活動録後編](https://genkai-io.hatenablog.jp/entry/2018/12/06/190000)
* [コンピュータシステムの理論と実装の1〜5章のハードウェアを実装しました（ネタバレ注意）](https://nihemak.hatenablog.com/entry/2019/04/28/150541#Not)