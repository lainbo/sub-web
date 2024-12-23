<template>
  <div>
    <div class="wrapper">
      <el-card class="form_card container">
        <div slot="header">
          Lainbo's subconverter
        </div>
        <el-container>
          <el-form size="medium" :model="form" label-width="88px" style="width: 100%">
            <!-- <el-form-item label="模式设置:">
              <el-radio v-model="advanced" label="1">基础模式</el-radio>
              <el-radio v-model="advanced" label="2">进阶模式</el-radio>
            </el-form-item> -->
            <el-form-item label="订阅链接:">
              <el-input v-model="form.sourceSubUrl" type="textarea" rows="3"
                placeholder="支持订阅链接, 或ss/ssr/vmess/vless/hysteria链接, 多个链接每行一个或用 | 分隔" @blur="saveSubUrl" />
            </el-form-item>
            <el-form-item label="客户端:">
              <el-select v-model="form.clientType" style="width: 100%">
                <el-option
                 v-for="(v, k) in options.clientTypes"
                 :key="k"
                 :label="k"
                 :value="v"
                 :disabled="![backendLink.lainboEnhance, backendLink.feiyang].includes(form.customBackend) && v==='singbox'"
                >
                </el-option>
              </el-select>
            </el-form-item>

            <div v-if="advanced === '2'">
              <el-form-item label="后端地址:">
                <el-select style="width: 100%" v-model="form.customBackend" filterable allow-create default-first-option
                  placeholder="动动小手，（建议）自行搭建后端服务。例：http://127.0.0.1:25500/sub?">
                  <el-option v-for="item in backendUrlOptions" :key="item.value" :label="item.label"
                    :value="item.value">
                  </el-option>
                </el-select>
              </el-form-item>
              <el-form-item label="远程配置:">
                <el-select v-model="form.remoteConfig" allow-create filterable placeholder="请选择" style="width: 100%">
                  <el-option-group v-for="group in options.remoteConfig" :key="group.label" :label="group.label">
                    <el-option v-for="item in group.options" :key="item.value" :label="item.label"
                      :value="item.value"></el-option>
                  </el-option-group>
                </el-select>
              </el-form-item>
              <el-form-item label="订阅文件名:">
                <el-input v-model.trim="form.filename" placeholder="输入给你提供订阅的服务商名字(可选)" />
              </el-form-item>
              <el-form-item label="包含节点:">
                <el-input v-model.trim="form.includeRemarks" placeholder="节点名包含的关键字，支持正则" />
              </el-form-item>
              <el-form-item label="排除节点:">
                <el-input v-model.trim="form.excludeRemarks" placeholder="节点名不包含的关键字，支持正则" />
              </el-form-item>
              <el-form-item label=" ">
                <el-popover placement="bottom" v-model="form.extraset">
                  <el-row>
                    <div>Emoji:</div>
                    <el-radio-group v-model="form.emoji" size="mini" label="Emoji">
                      <el-radio-button :label="undefined">订阅自带</el-radio-button>
                      <el-radio-button :label="true">规则内置</el-radio-button>
                      <el-radio-button :label="false">关闭</el-radio-button>
                    </el-radio-group>
                  </el-row>
                  <el-row style="margin-top: 8px;">
                    <el-checkbox v-model="form.scv" label="跳过证书验证"></el-checkbox>
                  </el-row>
                  <el-row>
                    <el-checkbox v-model="form.nodeList" label="输出为 Node List"></el-checkbox>
                  </el-row>
                  <el-row>
                    <el-checkbox v-model="form.udp" @change="needUdp = true" label="启用 UDP"></el-checkbox>
                  </el-row>
                  <el-row>
                    <el-checkbox v-model="form.appendType" label="节点类型"></el-checkbox>
                  </el-row>
                  <el-row>
                    <el-checkbox v-model="form.sort" label="排序节点"></el-checkbox>
                  </el-row>
                  <el-row>
                    <el-checkbox v-model="form.fdn" label="过滤非法节点"></el-checkbox>
                  </el-row>
                  <el-button slot="reference">更多选项</el-button>
                </el-popover>
                <!-- <el-popover placement="bottom" style="margin-left: 10px">
                  <el-row>
                    <el-checkbox v-model="form.tpl.surge.doh" label="Surge.DoH"></el-checkbox>
                  </el-row>
                  <el-row>
                    <el-checkbox v-model="form.tpl.clash.doh" label="Clash.DoH"></el-checkbox>
                  </el-row>
                  <el-row>
                    <el-checkbox v-model="form.insert" label="网易云"></el-checkbox>
                  </el-row>
                  <el-button slot="reference">定制功能</el-button>
                </el-popover> -->
              </el-form-item>
            </div>


            <el-divider content-position="center">
              <i class="el-icon-magic-stick"></i>
            </el-divider>

            <el-form-item label="新的订阅:">
              <el-input class="copy-content" readonly v-model="customSubUrl">
                <el-button slot="append" v-clipboard:copy="customSubUrl" v-clipboard:success="onCopy" ref="copy-btn"
                  icon="el-icon-document-copy">复制</el-button>
              </el-input>
            </el-form-item>
            <!-- <el-form-item label="订阅短链:">
              <el-input class="copy-content" disabled v-model="curtomShortSubUrl">
                <el-button slot="append" v-clipboard:copy="curtomShortSubUrl" v-clipboard:success="onCopy"
                  ref="copy-btn" icon="el-icon-document-copy">复制</el-button>
              </el-input>
            </el-form-item> -->

            <!-- <el-form-item label-width="0px" style="margin-top: 40px; text-align: center">
              
              <el-button style="width: 120px" type="danger" 
                :disabled="true">生成短链接</el-button>
              <el-button style="width: 120px" type="primary" @click="surgeInstall" icon="el-icon-connection">一键导入Surge</el-button>
            </el-form-item> -->

            <!-- <el-form-item label-width="0px" style="text-align: center">
              <el-button style="width: 120px" type="primary" @click="dialogUploadConfigVisible = true"
                icon="el-icon-upload" :loading="loading">上传配置</el-button>
              <el-button style="width: 250px" type="primary" @click="clashInstall" icon="el-icon-connection"
                :disabled="customSubUrl.length === 0">一键导入Clash</el-button>
            </el-form-item> -->
            <el-form-item label=" ">
              <div class="end_form">
                <el-button style="width: 250px" @click="dialogLoadConfigVisible = true"
                   :loading="loading">从URL解析</el-button>
                <el-button style="width: 250px" type="primary" @click="makeUrl"
                :disabled="form.sourceSubUrl.length === 0">生成订阅链接</el-button>
              </div>
            </el-form-item>
          </el-form>
        </el-container>
      </el-card>
    </div>
    
    <el-dialog :visible.sync="dialogUploadConfigVisible" :show-close="false" :close-on-click-modal="false"
      :close-on-press-escape="false" width="700px">
      <div slot="title">
        Remote config upload
        <el-popover trigger="hover" placement="right" style="margin-left: 10px">
          <el-link type="primary" :href="sampleConfig" target="_blank" icon="el-icon-info">参考配置</el-link>
          <i class="el-icon-question" slot="reference"></i>
        </el-popover>
      </div>
      <el-form label-position="left">
        <el-form-item prop="uploadConfig">
          <el-input v-model="uploadConfig" type="textarea" :autosize="{ minRows: 15, maxRows: 15 }" maxlength="5000"
            show-word-limit></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="uploadConfig = ''; dialogUploadConfigVisible = false">取 消</el-button>
        <el-button type="primary" @click="confirmUploadConfig" :disabled="uploadConfig.length === 0">确 定</el-button>
      </div>
    </el-dialog>

    <el-dialog :visible.sync="dialogLoadConfigVisible" :show-close="false" :close-on-click-modal="false"
      :close-on-press-escape="false" width="700px">
      <div slot="title">
        可以从老的订阅信息中解析信息,填入页面中去
      </div>
      <el-form label-position="left">
        <el-form-item prop="uploadConfig">
          <el-input v-model="loadConfig" type="textarea" :autosize="{ minRows: 15, maxRows: 15 }" maxlength="5000"
            show-word-limit></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="loadConfig = ''; dialogLoadConfigVisible = false">取 消</el-button>
        <el-button type="primary" @click="confirmLoadConfig" :disabled="loadConfig.length === 0">确 定</el-button>
      </div>
    </el-dialog>

  </div>
</template>

<script>
const project = process.env.VUE_APP_PROJECT
const remoteConfigSample = process.env.VUE_APP_SUBCONVERTER_REMOTE_CONFIG
const defaultBackend = process.env.VUE_APP_SUBCONVERTER_DEFAULT_BACKEND + '/sub?'
const configUploadBackend = process.env.VUE_APP_CONFIG_UPLOAD_BACKEND + '/config/upload'
const tgBotLink = process.env.VUE_APP_BOT_LINK
const backendLink = {
  lainboEnhance: 'https://api-sub.ours.day/sub?',
  feiyang: 'https://url.v1.mk/sub?',
  sublink: 'https://api.sublink.dev/sub?',
  nx: 'https://api.nexconvert.com/sub?',
  amy: 'https://amyconvert.com/sub?',
  imm: 'https://immconvert.com/sub?',
}
const originBackend = backendLink.lainboEnhance
export default {
  data() {
    return {
      backendLink,
      advanced: "2",

      // 是否为 PC 端
      isPC: true,

      options: {
        clientTypes: {
          Clash: "clash",
          Surge3: "surge&ver=3",
          Surge4: "surge&ver=4",
          "Sing-Box(仅Lainbo、肥羊后端支持)": "singbox",
          Quantumult: "quan",
          QuantumultX: "quanx",
          Surfboard: "surfboard",
          Loon: "loon",
          SSAndroid: "sssub",
          V2Ray: "v2ray",
          ss: "ss",
          ssr: "ssr",
          ssd: "ssd",
          ClashR: "clashr",
          Surge2: "surge&ver=2",
        },
        backendOptions: [{ value: "http://127.0.0.1:25500/sub?" }],
        remoteConfig: [
          {
            label: "customized",
            options: [
              {
                label: "Lainbo's config 默认配置",
                value: "https://u.lainbo.com/clash-config"
              },
              {
                label: "Lainbo's config 增强（若无欧洲节点，使用会导致网络异常）",
                value: "https://u.lainbo.com/clash-config-tg"
              },
              {
                label: "Lainbo's config 仅解决DNS泄露",
                value: "https://u.lainbo.com/clash-config-mini"
              },
              {
                label: "Lainbo's config 黑名单模式",
                value: "https://u.lainbo.com/clash-config-blocklist"
              },
            ]
          },
          {
            label: "ACL4SSR",
            options: [
              {
                label: "ACL4SSR_Online_Mini",
                value:
                  "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Mini.ini"
              },
              {
                label: "ACL4SSR_Online_Mini_AdblockPlus",
                value: "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/config/ACL4SSR_Online_Mini_AdblockPlus.ini"
              }
            ]
          },
        ]
      },
      form: {
        sourceSubUrl: "",
        clientType: "",
        customBackend: originBackend,
        remoteConfig: "https://u.lainbo.com/clash-config",
        excludeRemarks: "",
        includeRemarks: "",
        filename: "",
        emoji: undefined,
        nodeList: false,
        extraset: false,
        sort: false,
        udp: false,
        tfo: false,
        scv: false,
        fdn: false,
        appendType: false,
        insert: false, // 是否插入默认订阅的节点，对应配置项 insert_url
        new_name: true, // 是否使用 Clash 新字段

        // tpl 定制功能
        tpl: {
          surge: {
            doh: false // dns 查询是否使用 DoH
          },
          clash: {
            doh: false
          }
        }
      },
      backendUrlOptions: [
        {
          label: 'Lainbo的后端',
          value: backendLink.lainboEnhance
        },
        {
          label: '肥羊增强型后端',
          value: backendLink.feiyang
        },
        {
          label: '奶昔的后端',
          value: backendLink.nx
        },
        {
          label: 'Amy的后端',
          value: backendLink.amy
        },
        {
          label: 'imm的后端',
          value: backendLink.imm
        },
        {
          label: 'sublink',
          value: backendLink.sublink
        },  
      ],
      loading: false,
      customSubUrl: "",
      curtomShortSubUrl: "",
      dialogUploadConfigVisible: false,
      loadConfig: "",
      dialogLoadConfigVisible: false,
      uploadConfig: "",
      uploadPassword: "",
      myBot: tgBotLink,
      sampleConfig: remoteConfigSample,

      needUdp: false, // 是否需要添加 udp 参数
    };
  },
  created() {
    this.isPC = this.$getOS().isPc;

    // 获取 url cache
    if (process.env.VUE_APP_USE_STORAGE === 'true') {
      this.form.sourceSubUrl = this.getLocalStorageItem('sourceSubUrl')
    }
  },
  mounted() {
    this.form.clientType = "clash";
    // this.notify();
  },
  methods: {
    onCopy() {
      this.$message.success("已复制");
    },
    goToProject() {
      window.open(project);
    },
    gotoRemoteConfig() {
      window.open(remoteConfigSample);
    },
    clashInstall() {
      if (this.customSubUrl === "") {
        this.$message.error("请先填写必填项，生成订阅链接");
        return false;
      }

      const url = "clash://install-config?url=";
      window.open(
        url +
        encodeURIComponent(
          this.curtomShortSubUrl !== ""
            ? this.curtomShortSubUrl
            : this.customSubUrl
        )
      );
    },
    surgeInstall() {
      if (this.customSubUrl === "") {
        this.$message.error("请先填写必填项，生成订阅链接");
        return false;
      }

      const url = "surge://install-config?url=";
      window.open(url + this.customSubUrl);
    },
    makeUrl() {
      if (this.form.sourceSubUrl === "" || this.form.clientType === "") {
        this.$message.error("订阅链接与客户端为必填项");
        return false;
      }

      let backend =
        this.form.customBackend === ""
          ? defaultBackend
          : this.form.customBackend;

      let sourceSub = this.form.sourceSubUrl
      const parts = sourceSub.split(/\r\n|\n|\r/)
        .map(line =>
          line.split('|').map(part => part.trim()).filter(part => part !== '').join('|'),
        )
        .filter(part => part !== '') // 过滤掉空行
      sourceSub = parts.join('|')

      this.customSubUrl =
        backend +
        "target=" +
        this.form.clientType +
        "&url=" +
        encodeURIComponent(sourceSub) +
        "&insert=" +
        this.form.insert;

      if (this.advanced === "2") {
        const params = {
          config: this.form.remoteConfig ? encodeURIComponent(this.form.remoteConfig) : null,
          exclude: this.form.excludeRemarks ? encodeURIComponent(this.form.excludeRemarks) : null,
          include: this.form.includeRemarks ? encodeURIComponent(this.form.includeRemarks) : null,
          filename: this.form.filename ? encodeURIComponent(this.form.filename) : null,
          append_type: this.form.appendType ? this.form.appendType.toString() : null,
          list: this.form.nodeList,
          tfo: this.form.tfo,
          scv: this.form.scv,
          fdn: this.form.fdn,
          sort: this.form.sort,
          emoji: this.form.emoji !== undefined ? this.form.emoji : null,
          udp: this.needUdp ? this.form.udp?.toString() : null,
          "surge.doh": this.form.tpl.surge.doh === true ? "true" : null,
          "clash.doh": this.form.clientType === "clash" && this.form.tpl.clash.doh === true ? "true" : null,
          new_name: this.form.clientType === "clash" ? this.form.new_name?.toString() : null
        };

        const filteredParams = Object.entries(params)
          // eslint-disable-next-line no-unused-vars
          .filter(([_, value]) => value !== null)  // 去除值为null的键值对
          .map(([key, value]) => `${key}=${value}`)
          .join('&');

        this.customSubUrl += `&${filteredParams}`;
      }


      this.$copyText(this.customSubUrl);
      this.$message.success("新的订阅链接已复制到剪贴板");
    },
    notify() {
      const h = this.$createElement;

      this.$notify({
        title: "隐私提示",
        type: "warning",
        message: h(
          "i",
          { style: "color: teal" },
          "各种订阅链接（短链接服务除外）生成纯前端实现，无隐私问题。默认提供后端转换服务，隐私担忧者请自行搭建后端服务。"
        )
      });
    },
    confirmUploadConfig() {
      if (this.uploadConfig === "") {
        this.$message.warning("远程配置不能为空");
        return false;
      }

      this.loading = true;

      let data = new FormData();
      data.append("password", this.uploadPassword);
      data.append("config", this.uploadConfig);

      this.$axios
        .post(configUploadBackend, data, {
          header: {
            "Content-Type": "application/form-data; charset=utf-8"
          }
        })
        .then(res => {
          if (res.data.code === 0 && res.data.data.url !== "") {
            this.$message.success(
              "远程配置上传成功，配置链接已复制到剪贴板，有效期三个月望知悉"
            );

            // 自动填充至『表单-远程配置』
            this.form.remoteConfig = res.data.data.url;
            this.$copyText(this.form.remoteConfig);

            this.dialogUploadConfigVisible = false;
          } else {
            this.$message.error("远程配置上传失败: " + res.data.msg);
          }
        })
        .catch(() => {
          this.$message.error("远程配置上传失败");
        })
        .finally(() => {
          this.loading = false;
        });
    },
    confirmLoadConfig() {
      // 怎么解析短链接的302和301...
      if (this.loadConfig.indexOf("target") === -1) {
        this.$message.error("请输入正确的订阅地址,暂不支持短链接!");
        return;
      }
      let url
      try {
        url = new URL(this.loadConfig)
      } catch (error) {
        this.$message.error("请输入正确的订阅地址!");
        return;
      }
      this.form.customBackend = url.origin + url.pathname + "?"
      let param = new URLSearchParams(url.search);
      if (param.get("target")) {
        let target = param.get("target");
        if (target === 'surge' && param.get("ver")) {
          // 类型为surge,有ver
          this.form.clientType = target + "&ver=" + param.get("ver");
        } else if (target === 'surge') {
          //类型为surge,没有ver
          this.form.clientType = target + "&ver=4"
        } else {
          //类型为其他
          this.form.clientType = target;
        }
      }
      if (param.get("url")) {
        this.form.sourceSubUrl = param.get("url");
      }
      if (param.get("insert")) {
        this.form.insert = param.get("insert") === 'true';
      }
      if (param.get("config")) {
        this.form.remoteConfig = param.get("config");
      }
      if (param.get("exclude")) {
        this.form.excludeRemarks = param.get("exclude");
      }
      if (param.get("include")) {
        this.form.includeRemarks = param.get("include");
      }
      if (param.get("filename")) {
        this.form.filename = param.get("filename");
      }
      if (param.get("append_type")) {
        this.form.appendType = param.get("append_type") === 'true';
      }
      if (param.get("emoji")) {
        this.form.emoji = param.get("emoji") === 'true';
      }
      if (param.get("list")) {
        this.form.nodeList = param.get("list") === 'true';
      }
      if (param.get("tfo")) {
        this.form.tfo = param.get("tfo") === 'true';
      }
      if (param.get("scv")) {
        this.form.scv = param.get("scv") === 'true';
      }
      if (param.get("fdn")) {
        this.form.fdn = param.get("fdn") === 'true';
      }
      if (param.get("sort")) {
        this.form.sort = param.get("sort") === 'true';
      }
      if (param.get("udp")) {
        this.form.udp = param.get("udp") === 'true';
      }
      if (param.get("surge.doh")) {
        this.form.tpl.surge.doh = param.get("surge.doh") === 'true';
      }
      if (param.get("clash.doh")) {
        this.form.tpl.clash.doh = param.get("clash.doh") === 'true';
      }
      if (param.get("new_name")) {
        this.form.new_name = param.get("new_name") === 'true';
      }
      this.dialogLoadConfigVisible = false;
    },
    createFilter(queryString) {
      return candidate => {
        return (
          candidate.value.toLowerCase().indexOf(queryString.toLowerCase()) === 0
        );
      };
    },
    saveSubUrl() {
      if (this.form.sourceSubUrl !== '') {
        this.setLocalStorageItem('sourceSubUrl', this.form.sourceSubUrl)
      }
    },
    getLocalStorageItem(itemKey) {
      const now = +new Date()
      let ls = localStorage.getItem(itemKey)

      let itemValue = ''
      if (ls !== null) {
        let data = JSON.parse(ls)
        if (data.expire > now) {
          itemValue = data.value
        } else {
          localStorage.removeItem(itemKey)
        }
      }

      return itemValue
    },
    setLocalStorageItem(itemKey, itemValue) {
      const ttl = process.env.VUE_APP_CACHE_TTL
      const now = +new Date()

      let data = {
        setTime: now,
        ttl: parseInt(ttl),
        expire: now + ttl * 1000,
        value: itemValue
      }
      localStorage.setItem(itemKey, JSON.stringify(data))
    }
  },
  watch: {
    // 'form.sourceSubUrl'(newVal) {
    //   const customBackendMap = [
    //     { key: 'oxycontin.cc', value: backendLink.sublink },
    //     { key: '-ytoo', value: backendLink.sublink },
    //     { key: 'ljcmlu.lol', value: backendLink.nx },
    //     { key: '-nx', value: backendLink.nx },
    //     { key: 'vlrzgf.sbs', value: backendLink.imm },
    //     { key: '-imm', value: backendLink.imm },
    //   ];
    //   const matchedBackend = customBackendMap.find(entry => newVal.includes(entry.key));
    //   this.form.customBackend = matchedBackend?.value || originBackend;
    // },
    'form.customBackend'() {
      if (!this.isSingboxBackend && this.form.clientType === 'singbox') {
        this.$message.error("当前后端不支持Singbox客户端，已自动切换转换目标为Clash");
        this.form.clientType = 'clash';
      }
    }
  },
  computed: {
    // 当前是支持singbox的后端
    isSingboxBackend() {
      return [backendLink.lainboEnhance, backendLink.feiyang].includes(this.form.customBackend);
    }
  }
};
</script>
<style scoped>
.wrapper {
  display: flex;
  justify-content: center;
  position: absolute;
  inset: 0;
  top: -8vh;
  top: calc(var(--1dvh, 1vh) * -8);
  top: -8dvh;
  margin: auto;
  width: 100%;
  height: fit-content;
}
.form_card {
  border-radius: 12px;
  box-shadow: 0 25px 50px -12px rgb(0 0 0 / 0.25);
}
.end_form {
  display: flex;
  justify-content: end;
}
</style>
