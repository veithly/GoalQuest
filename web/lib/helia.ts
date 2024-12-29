import { createHelia } from "helia";
import { dagCbor } from "@helia/dag-cbor";
import { CID } from "multiformats/cid";

async function getMissionData(hash: string) {
  try {
    // 创建新的 Helia 实例
    const helia = await createHelia();
    const d = dagCbor(helia);

    // 将 hash 字符串解析为 CID
    const cid = CID.parse(hash);

    // 获取数据
    const data = await d.get(cid);
    return data;
  } catch (error) {
    console.error("Error fetching mission data:", error);
    throw error;
  }
}

let dagIns;

export const dag = async () => {
  if (dagIns) {
    return dagIns;
  }
  // 创建新的 Helia 实例
  const helia = await createHelia();
  dagIns = dagCbor(helia);
  return dagIns;
};

export const get = async (hash: string) => {
  const cid = CID.parse(hash);
  const dagIns = await dag();
  const data = dagIns.get(cid);
  return data;
};

export const add = async (json: any) => {
  const dagIns = await dag();
  const cidWithSHA256 = await dagIns.add(json);
  const hash = cidWithSHA256.toString();
  return hash;
};

export const d = {
  get,
  add,
};
